require 'helper'
require 'peddler/parser'

class CSVParserTest < MiniTest::Test
  def setup
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    headers = { 'Content-Type' => 'application/octet-stream', 'Content-MD5' => 'SmZIMTs2mCO8u8QzR5LE7Q==' }
    res = OpenStruct.new(body: body, headers: headers)

    @parser = Peddler::Parser.parse(res)
  end

  def test_parses_data
    assert_kind_of CSV::Table, @parser.parse
  end

  def test_summarises
    refute_empty @parser.records_count
  end

  def test_validates
    assert @parser.valid?
  end
end
