describe OpenURI do
  describe '.open_http' do
    context 'when request with basic authentication' do
      it 'opens dangerous uri' do
        stub_request(:any, 'user:pass@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://user:pass@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'opens dangerous uri(userinfo has two ":")' do
        stub_request(:any, 'user:pass@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://user:pass:broken@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end
    end

    context 'when request no basic authentication' do
      it 'opens nomal url' do
        stub_request(:any, 'www.example.com/index.html').to_return(body: 'aaa')
        expect(
          open('http://www.example.com/index.html').read
        ).to eq('aaa')
      end
    end
  end
end
