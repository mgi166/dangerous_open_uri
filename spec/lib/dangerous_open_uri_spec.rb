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

      it 'receives the option[:http_basic_authentication] from the uri of argument' do
        expect(OpenURI).to receive(:original_open_http)
          .with(
            kind_of(OpenURI::Buffer),
            URI.parse('http://www.example.com/secret/page.html'),
            nil,
            http_basic_authentication: ['user', 'pass']
          )

        open('http://user:pass@www.example.com/secret/page.html')
      end

      it 'given userinfo has two ":" opens dangerous uri' do
        stub_request(:any, 'user:pass:broken@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          # user = "user", password = "pass:broken"
          open('http://user:pass:broken@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'given has user but no password opens dangerous uri' do
        stub_request(:any, 'user:@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://user:@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'given no user but has password opens dangerous uri' do
        stub_request(:any, ':pass@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://:pass@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'given userinfo == ":" opens dangerous uri' do
        stub_request(:any, 'www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://:@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'given userinfo not include ":" opens dangerous uri' do
        stub_request(:any, 'baduserinfo:@www.example.com/secret/page.html')
          .to_return(body: 'aaa')

        expect(
          open('http://baduserinfo@www.example.com/secret/page.html').read
        ).to eq('aaa')
      end

      it 'given proxy option as dangrous uri, original_open_http receives the correct proxy arguments' do
        uri       = URI.parse('http://www.example.com/secret/page.html')
        proxy_uri = URI.parse('http://proxy.example.com')
        proxy     = [proxy_uri, 'user', 'pass']

        expect(OpenURI).to receive(:original_open_http)
          .with(
            kind_of(OpenURI::Buffer),
            uri,
            proxy,
            proxy: 'http://user:pass@proxy.example.com'
          )

        open('http://www.example.com/secret/page.html', proxy: 'http://user:pass@proxy.example.com')
      end
    end

    context 'when request no basic authentication' do
      it 'opens nomal url' do
        stub_request(:any, 'www.example.com/index.html').to_return(body: 'aaa')
        expect(
          open('http://www.example.com/index.html').read
        ).to eq('aaa')
      end

      it 'given bad uri raises error' do
        expect do
          open('http://@@www.example.com/secret/page.html').read
        end.to raise_error URI::InvalidURIError
      end
    end
  end
end
