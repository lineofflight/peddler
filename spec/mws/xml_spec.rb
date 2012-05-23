require 'spec_helper'

module MWS
  describe XML do
    describe '.to_hash' do
      subject do
        str = <<-XML.gsub!(/>\s+</, '><').strip!
        <?xml version=\"1.0\" ?>
        <ItemAttributes>
          <Title>Anti-Oedipus</Title>
          <Author>Gilles Deleuze</Author>
          <Author>Felix Guattari</Author>
          <Creator Role="Translator">Robert Hurley</Creator>
        </ItemAttributes>
        XML
        xml = Nokogiri::XML.parse str

        XML.to_hash xml
      end

      it 'returns a hash' do
        should be_an_instance_of Hash
      end

      it 'handles single children' do
        subject['Title'].should eq 'Anti-Oedipus'
      end

      it 'handles arrays' do
        subject['Author'].should be_a Array
      end

      it 'handles attributes' do
        node = subject['Creator']
        node['Role'].should eq 'Translator'
        node['__content__'].should eq 'Robert Hurley'
      end
    end
  end
end
