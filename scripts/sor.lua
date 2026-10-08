--[[
Pandoc filter: a Seeds of Renaissance paper's Markdown -> calls into the
sor Typst style (typst/lib/styles/sor.typ).

The paper's Markdown is plain enough to read on GitHub, so its structure is
carried by convention rather than markup. This filter recovers it, and fails
loudly where a convention is broken rather than guessing:

  ## N. Title: after       numbered chapter (opening page, recto)
  ## Title                 unnumbered part: prelims before the introduction,
                           back matter after the conclusion
  ### / ####               section / sub-section
  <aside class="section-summary"> ... </aside>
                           summary box (bold in the source, so it still reads
                           as distinct where the class is ignored)
  *“quote”* + attribution  displayed quotation; the attribution is the next
                           line ("― Name") or a one-item list ("- Name")
  first such quotation directly under a chapter heading
                           the chapter's epigraph
  image + "*Fig N: Title. Caption*"
                           figure as a plate
  annotated contents list  the paper's contents page, with page numbers
  <!-- ... -->             dropped

See docs/styles/sor.md for what each becomes on the page.
]]

local stringify = pandoc.utils.stringify

-- Where the build copies the paper's assets, root-absolute for Typst.
local ASSET_PREFIX = os.getenv("SOR_ASSET_PREFIX") or "/typst/build/paper/"

-- ---- Typst emission ------------------------------------------------------

local function typst_inlines(inlines)
  -- Render inlines to Typst markup by round-tripping through the writer.
  local doc = pandoc.Pandoc({ pandoc.Plain(inlines) })
  return (pandoc.write(doc, "typst"):gsub("%s+$", ""))
end

local function typst_blocks(blocks)
  return (pandoc.write(pandoc.Pandoc(blocks), "typst"):gsub("%s+$", ""))
end

local function str_lit(s)
  return '"' .. s:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

local function raw(s) return pandoc.RawBlock("typst", s) end

-- ---- Inline helpers ------------------------------------------------------

local function trim_inlines(inl)
  inl = pandoc.List(inl)
  while #inl > 0 and (inl[1].t == "Space" or inl[1].t == "SoftBreak" or inl[1].t == "LineBreak") do inl:remove(1) end
  while #inl > 0 and (inl[#inl].t == "Space" or inl[#inl].t == "SoftBreak" or inl[#inl].t == "LineBreak") do inl:remove(#inl) end
  return inl
end

-- Strip a leading dash used to introduce an attribution: "- ", "– ", "― ".
local function strip_dash(inl)
  inl = trim_inlines(inl)
  if #inl > 0 and inl[1].t == "Str" then
    local s = inl[1].text:gsub("^[-–—―]+", "")
    if s == "" then inl:remove(1) else inl[1] = pandoc.Str(s) end
  end
  return trim_inlines(inl)
end

-- Strip a trailing dash inside a quotation (`*“…” –*Name`).
local function strip_trailing_dash(inl)
  inl = trim_inlines(inl)
  if #inl > 0 and inl[#inl].t == "Str" then
    local s = inl[#inl].text:gsub("[-–—―]+$", "")
    if s == "" then inl:remove(#inl) else inl[#inl] = pandoc.Str(s) end
  end
  return trim_inlines(inl)
end

-- Emphasis is the source's only marker of a displayed quotation, so a
-- quotation is a paragraph that opens with an Emph whose text opens with a
-- quotation mark. Returns quote inlines and any trailing inlines (an
-- attribution set on the same line or after a line break).
local function quote_parts(para)
  if para.t ~= "Para" then return nil end
  local c = trim_inlines(para.content)
  if #c == 0 or c[1].t ~= "Emph" then return nil end
  local first = stringify(c[1].content):gsub("^%s+", "")
  if not (first:match("^“") or first:match("^\"") or first:match("^%.%.%.")) then return nil end
  local rest = pandoc.List()
  for i = 2, #c do rest:insert(c[i]) end
  return c[1].content, rest
end

-- Footnote marks hanging off the end of a quotation belong to it, not to
-- the attribution.
local function split_notes(rest)
  local notes, other = pandoc.List(), pandoc.List()
  for _, x in ipairs(rest) do
    if x.t == "Note" and #trim_inlines(other) == 0 then notes:insert(x) else other:insert(x) end
  end
  return notes, other
end

local function unstrong(blocks)
  return pandoc.Blocks(blocks):walk({ Strong = function(s) return s.content end })
end

-- ---- Headings ------------------------------------------------------------

-- "1. Decision-making the modern way: questions of quantity"
--   -> "1", "Decision-making the modern way", "questions of quantity"
local function chapter_parts(header)
  local text = stringify(header.content)
  local num, rest = text:match("^(%d+)%.%s+(.*)$")
  if not num then return nil end
  local title, after = rest:match("^(.-):%s+(.*)$")
  if not title then
    title, after = rest:match("^(.-%?)%s+(.*)$")
  end
  return num, title or rest, after
end

local FRONT = { ["summary"] = true, ["preface"] = true }
local BACK_NEW_PAGE = { ["further reading"] = true, ["bibliography"] = true, ["appendices"] = true }
-- parts whose paragraphs are entries in a list of references
local REFERENCES = { ["further reading"] = true, ["bibliography"] = true }

-- ---- Annotated contents --------------------------------------------------

local function contents_entries(list, level, out)
  for _, item in ipairs(list.content) do
    local para = item[1]
    local link, summary = nil, pandoc.List()
    local seen_dash = false
    for _, x in ipairs(para.content) do
      if not link and x.t == "Link" then
        link = x
      elseif link and not seen_dash and x.t == "Str" and (x.text == "—" or x.text == "–") then
        seen_dash = true
      elseif seen_dash then
        summary:insert(x)
      end
    end
    if not link then error("annotated contents: list item without a link: " .. stringify(para)) end
    local target = link.target:gsub("^#", "")
    local s = trim_inlines(summary)
    -- "1. Title" -> number "1", title "Title"
    local title, number = link.content, "none"
    local n, rest = stringify(link.content):match("^(%d+)%.%s+(.*)$")
    if n then title, number = pandoc.Inlines(rest), str_lit(n) end
    out:insert(string.format("(level: %d, target: %s, number: %s, title: [%s], summary: %s)",
      level, str_lit(target), number, typst_inlines(title),
      #s > 0 and ("[" .. typst_inlines(s) .. "]") or "none"))
    for i = 2, #item do
      if item[i].t == "BulletList" then contents_entries(item[i], level + 1, out) end
    end
  end
  return out
end

-- ---- Main pass -----------------------------------------------------------

local function header_label(h)
  return h.identifier ~= "" and (" <" .. h.identifier .. ">") or ""
end

function Pandoc(doc)
  local blocks = doc.blocks
  local out = pandoc.List()
  local i = 1
  local in_refs = false
  local fig_seen = 0

  local function attribution_after(idx)
    -- A one-item list straight after the quotation is its attribution.
    local nxt = blocks[idx]
    if nxt and nxt.t == "BulletList" and #nxt.content == 1 and #nxt.content[1] == 1 then
      return nxt.content[1][1].content, idx + 1
    end
    return nil, idx
  end

  local function quote_call(fn, q, attr, notes)
    q = strip_trailing_dash(q)
    local body = typst_inlines(q) .. (notes and #notes > 0 and typst_inlines(notes) or "")
    local a = attr and #attr > 0 and ("[" .. typst_inlines(strip_dash(attr)) .. "]") or "none"
    -- Past a few lines a quotation is set smaller: a pull quote's size
    -- does not hold over a paragraph.
    local _, words = stringify(q):gsub("%S+", "")
    local long = (fn == "quotation" and words > 60) and ", long: true" or ""
    return string.format("#%s(attribution: %s%s)[%s]", fn, a, long, body)
  end

  -- Parse a quotation at blocks[idx]; returns quote, attribution, notes, next index.
  local function take_quote(idx)
    local q, rest = quote_parts(blocks[idx])
    if not q then return nil end
    local notes, after = split_notes(rest)
    local attr = strip_dash(after)
    local nxt = idx + 1
    if #attr == 0 then
      local a, n = attribution_after(idx + 1)
      if a then attr, nxt = pandoc.List(a), n end
    end
    -- An attribution in italics is still an attribution.
    if #attr == 1 and attr[1].t == "Emph" then attr = attr[1].content end
    return q, attr, notes, nxt
  end

  while i <= #blocks do
    local b = blocks[i]

    if b.t == "RawBlock" and b.format == "html" and b.text:match("^<!%-%-") then
      -- comment: drop
      i = i + 1

    elseif b.t == "RawBlock" and b.format == "html" and b.text:match('^<aside class="section%-summary">') then
      local inner = pandoc.List()
      i = i + 1
      while i <= #blocks and not (blocks[i].t == "RawBlock" and blocks[i].text:match("^</aside>")) do
        inner:insert(blocks[i]); i = i + 1
      end
      if i > #blocks then error("section-summary aside is never closed") end
      i = i + 1
      out:insert(raw("#summary[\n" .. typst_blocks(unstrong(inner)) .. "\n]"))

    elseif b.t == "Header" and b.level == 2 then
      local key = stringify(b.content):lower()
      if key == "annotated contents" then
        -- the list that follows becomes the contents page
        local j = i + 1
        while blocks[j] and blocks[j].t ~= "BulletList" do j = j + 1 end
        if not blocks[j] then error("annotated contents: no list") end
        local entries = contents_entries(blocks[j], 1, pandoc.List())
        out:insert(raw("#contents-page((\n  " .. table.concat(entries, ",\n  ") .. ",\n))"))
        i = j + 1
      else
        local num, title, after = chapter_parts(b)
        local kind
        if num then
          kind = "chapter"
        elseif FRONT[key] then
          kind = "prelim"
        elseif key == "introduction" then
          kind = "introduction"
        elseif key == "conclusion" then
          kind = "conclusion"
        elseif BACK_NEW_PAGE[key] then
          kind = "back"
        else
          error("unrecognised part heading: " .. stringify(b.content))
        end
        in_refs = REFERENCES[key] or false
        i = i + 1
        -- An opening quotation directly under a chapter title is its epigraph.
        local epigraph = "none"
        if kind == "chapter" or kind == "introduction" or kind == "conclusion" then
          local q, attr, notes, nxt = take_quote(i)
          if q then
            epigraph = quote_call("epigraph", q, attr, notes):gsub("^#", "")
            i = nxt
          end
        end
        local args = { "kind: " .. str_lit(kind), "epigraph: " .. epigraph }
        if num then
          table.insert(args, "number: " .. num)
          table.insert(args, "title: [" .. typst_inlines(pandoc.Inlines(title)) .. "]")
          if after then table.insert(args, "after: [" .. typst_inlines(pandoc.Inlines(after)) .. "]") end
        else
          table.insert(args, "title: [" .. typst_inlines(b.content) .. "]")
        end
        local full = num and (num .. ". " .. stringify(b.content):gsub("^%d+%.%s+", "")) or stringify(b.content)
        out:insert(raw(string.format("#opening(%s)[#heading(level: 1)[%s]%s]",
          table.concat(args, ", "), typst_inlines(pandoc.Inlines(full)), header_label(b))))
      end

    elseif b.t == "Header" and (b.level == 3 or b.level == 4) then
      out:insert(raw(string.rep("=", b.level - 1) .. " " .. typst_inlines(b.content) .. header_label(b)))
      i = i + 1

    elseif b.t == "Figure" or (b.t == "Para" and #b.content == 1 and b.content[1].t == "Image") then
      local img
      if b.t == "Figure" then
        b:walk({ Image = function(x) img = img or x end })
      else
        img = b.content[1]
      end
      local src = img.src:gsub("^%./", "")
      i = i + 1
      fig_seen = fig_seen + 1
      local num, title, caption = tostring(fig_seen), nil, nil
      -- "*Fig 1: Wisdom Gap. A rapidly growing gap …*" on the next line
      local nxt = blocks[i]
      if nxt and nxt.t == "Para" and #trim_inlines(nxt.content) >= 1 and nxt.content[1].t == "Emph"
          and stringify(nxt.content[1]):match("^Fig%.?%s*%d+") then
        local inl = pandoc.List()
        for _, x in ipairs(nxt.content[1].content) do inl:insert(x) end
        for k = 2, #nxt.content do inl:insert(nxt.content[k]) end
        -- drop "Fig N:" (up to three Str tokens)
        local head = stringify(inl[1])
        local n = head:match("^Fig%.?(%d+)")
        if n then
          inl:remove(1)
        else
          inl:remove(1); while #inl > 0 and inl[1].t == "Space" do inl:remove(1) end
          n = stringify(inl[1]):match("^(%d+)"); inl:remove(1)
        end
        num = n
        inl = trim_inlines(inl)
        -- title: up to the first token ending in a full stop
        local t = pandoc.List()
        while #inl > 0 do
          local x = inl:remove(1)
          t:insert(x)
          if x.t == "Str" and x.text:match("%.$") then break end
        end
        title, caption = t, trim_inlines(inl)
        i = i + 1
      else
        title = pandoc.Inlines(img.caption and #img.caption > 0 and img.caption or pandoc.Inlines(stringify(img)))
        if b.t == "Figure" and #b.caption.long > 0 then title = pandoc.utils.blocks_to_inlines(b.caption.long) end
      end
      out:insert(raw(string.format("#plate(%s, number: %s, title: [%s], caption: %s)",
        str_lit(ASSET_PREFIX .. src), str_lit(num), typst_inlines(title),
        caption and #caption > 0 and ("[" .. typst_inlines(caption) .. "]") or "none")))

    else
      local q, attr, notes, nxt = take_quote(i)
      if q then
        out:insert(raw(quote_call("quotation", q, attr, notes)))
        i = nxt
      elseif in_refs and b.t == "Para" and stringify(b.content):sub(1, 80):match("%d%d%d%d") then
        -- an entry has its year near the start; anything else is prose
        -- reading lists and references hang their second lines
        out:insert(raw("#reference[" .. typst_inlines(b.content) .. "]"))
        i = i + 1
      else
        out:insert(b)
        i = i + 1
      end
    end
  end

  doc.blocks = out
  return doc
end
