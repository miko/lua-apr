--[[

 Unit tests for the XML parsing module of the Lua/APR binding.

 Author: Peter Odding <peter@peterodding.com>
 Last Change: February 11, 2011
 Homepage: http://peterodding.com/code/lua/apr/
 License: MIT

--]]

local apr = require 'apr'
local helpers = require 'apr.test.helpers'

local function parse_xml(text)
  local parser = assert(apr.xml())
  assert(parser:feed(text))
  assert(parser:done())
  local info = assert(parser:getinfo())
  assert(parser:close())
  return info
end

local function deepequal(a, b)
  if type(a) ~= 'table' or type(b) ~= 'table' then
    return a == b
  else
    for k, v in pairs(a) do
      if not deepequal(v, b[k]) then
        return false
      end
    end
    for k, v in pairs(b) do
      if not deepequal(v, a[k]) then
        return false
      end
    end
    return true
  end
end

-- Empty root element.
assert(deepequal(parse_xml '<elem/>',
    { tag = 'elem' }))

-- Element with a single attribute.
assert(deepequal(parse_xml '<elem name="value" />',
    { tag = 'elem', attr = { 'name', name = 'value' } }))

-- Element with multiple attributes.
assert(deepequal(parse_xml '<elem name="value" a2="2" a3="3" />',
    { tag = 'elem', attr = { 'name', 'a2', 'a3', name = 'value', a2 = '2', a3 = '3' }}))

-- Element with text child node.
assert(deepequal(parse_xml '<elem>text</elem>',
    { tag = 'elem', 'text' }))

-- Element with child element.
assert(deepequal(parse_xml '<elem><child/></elem>',
    { tag = 'elem', { tag = 'child' } }))

-- Element with child element that contains a text node.
assert(deepequal(parse_xml '<parent><child>text</child></parent>',
    { tag = 'parent', { tag = 'child', 'text' } }))

-- Create a temporary XML file to test the alternative constructor.
local xml_path = helpers.tmpname()
helpers.writefile(xml_path, '<parent><child>text</child></parent>')
local parser = assert(apr.xml(xml_path))
assert(deepequal(parser:getinfo(),
    { tag = 'parent', { tag = 'child', 'text' } }))

-- Check that tostring(apr.xml()) works as expected.
local parser = assert(apr.xml())
assert(tostring(parser):find '^xml parser %([x%x]+%)$')
assert(parser:close())
assert(tostring(parser):find '^xml parser %(closed%)$')