require 'helper'
require 'peddler/flat_file_parser'

class TestPeddlerFlatFileParser < MiniTest::Test
  def setup
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    body.encode!('ASCII-8BIT')
    headers = { 'Content-Type' => 'application/octet-stream', 'Content-MD5' => 'SmZIMTs2mCO8u8QzR5LE7Q==' }
    res = OpenStruct.new(body: body, headers: headers)

    @parser = Peddler::FlatFileParser.new(res, 'ISO-8859-1')
  end

  def test_parses_data
    assert_kind_of CSV::Table, @parser.parse
  end

  def test_parses_data_a_line_at_a_time
    counter = 0
    @parser.parse { counter += 1 }
    assert counter > 0
  end

  def test_summarises
    refute_empty @parser.records_count
  end

  def test_validates
    assert @parser.valid?
  end

  def test_handles_reports_without_a_summary
    res = OpenStruct.new(body: "Foo\nBar\n")
    parser = Peddler::FlatFileParser.new(res, 'ISO-8859-1')

    refute_empty parser.content
  end

  def test_handles_japanese_flat_files
    body = "Foo\nこんにちは\n"
    body.encode!('SHIFT_JIS')
    body.force_encoding('ASCII-8BIT')
    res = OpenStruct.new(body: body)
    parser = Peddler::FlatFileParser.new(res, 'SHIFT_JIS')

    assert_equal 'こんにちは', parser.parse[0]['Foo']
  end
end
