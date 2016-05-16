require 'helper'
require 'peddler/flat_file_parser'

class TestPeddlerFlatFileParser < MiniTest::Test
  def test_parses_data
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    body.encode!('ASCII-8BIT')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    assert_kind_of CSV::Table, parser.parse
  end

  def test_parses_data_a_line_at_a_time
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    body.encode!('ASCII-8BIT')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    counter = 0
    parser.parse { counter += 1 }
    assert counter > 0
  end

  def test_summarises
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    body.encode!('ASCII-8BIT')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    refute_empty parser.records_count
  end
  end

  def test_validates
    body = "Feed Processing Summary:\n\tNumber of records processed\t\t11006\n\tNumber of records successful\t\t11006\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n1822\t85da472e-ba6c-11e3-95af-002590a74356\t5000\tWarning\tThe update for Sku '85da472e-ba6c-11e3-95af-002590a74356' was skipped because it is identical to the update in feed '9518995390'.\n"
    body.encode!('ASCII-8BIT')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ISO-8859-1')
    assert parser.valid?
  end

  def test_handles_reports_without_a_summary
    response = OpenStruct.new(body: "Foo\nBar\n")
    parser = Peddler::FlatFileParser.new(response, 'ISO-8859-1')
    refute_empty parser.content
  end

  def test_handles_japanese_flat_files
    body = "Foo\nこんにちは\n"
    body.encode!('SHIFT_JIS')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'Windows-31J')
    assert_equal 'こんにちは', parser.parse[0]['Foo']
  end

  def test_handles_japanese_curly_braces
    body = "Foo\n〝\n"
    body.encode!('Windows-31J')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'Windows-31J')
    assert_equal '〝', parser.parse[0]['Foo']
  end

  def test_handles_latin_1_flat_files
    body = "Foo\n™\n"
    body.encode!('Cp1252')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'Cp1252')
    assert_equal '™', parser.parse['Foo'][0]
  end

  def test_handles_undefined_characters
    body = "Foo\n\xFF\n"
    body.force_encoding('ASCII-8BIT')
    parser = Peddler::FlatFileParser.new(build_mock_response(body), 'ASCII-8BIT')
    assert_equal '?', parser.parse['Foo'][0]
  end

  private

  def build_mock_response(body)
    body.force_encoding('ASCII-8BIT')
    headers = {
      'Content-MD5' => Digest::MD5.base64digest(body)
    }

    OpenStruct.new(body: body, headers: headers)
  end
end
