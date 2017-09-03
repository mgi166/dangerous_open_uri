require 'net/ftp'

describe OpenURI do
  describe '.open_http' do
    context 'when request with basic authentication' do
      it 'opens dangerous uri' do
        stub_request(:any, 'www.example.com/secret/page.html')
          .with(headers: { Authorization: 'Basic dXNlcjpwYXNz' })
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

      context 'given userinfo has two ":"' do
        it 'opens with user and password(includes ":")' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic dXNlcjpwYXNzOmJyb2tlbg==' })
            .to_return(body: 'aaa')

          expect(
            # user = "user", password = "pass:broken"
            open('http://user:pass:broken@www.example.com/secret/page.html').read
          ).to eq('aaa')
        end
      end

      context 'given has user but no password' do
        it 'opens with user only' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic dXNlcjo=' })
            .to_return(body: 'aaa')

          expect(
            open('http://user:@www.example.com/secret/page.html').read
          ).to eq('aaa')
        end
      end

      context 'given no user but has password' do
        it 'opens with password only' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic OnBhc3M=' })
            .to_return(body: 'aaa')

          expect(
            open('http://:pass@www.example.com/secret/page.html').read
          ).to eq('aaa')
        end
      end

      context 'given userinfo == ":"' do
        it 'opens with no user and password' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic Og==' })
            .to_return(body: 'aaa')

          expect(
            open('http://:@www.example.com/secret/page.html').read
          ).to eq('aaa')
        end
      end

      context 'given userinfo not include ":"' do
        it 'opens with only user' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic YmFkdXNlcmluZm86' })
            .to_return(body: 'aaa')

          expect(
            open('http://baduserinfo@www.example.com/secret/page.html').read
          ).to eq('aaa')
        end
      end

      describe 'given URI::Generic object' do
        it ' does not change the argument object' do
          stub_request(:any, 'www.example.com/secret/page.html')
            .with(headers: { Authorization: 'Basic dXNlcjpwYXNz' })
            .to_return(body: 'aaa')

          uri = URI.parse('http://user:pass@www.example.com/secret/page.html')

          open(uri)
          expect(uri).to eq(uri)
        end

        context 'when password includes ":"' do
          it 'opens with user and password(includes ":")' do
            stub_request(:any, 'www.example.com/secret/page.html')
              .with(headers: { Authorization: 'Basic dXNlcjpwYXNzOndvcmQ=' })
              .to_return(body: 'aaa')

            uri = URI.parse('http://user:pass:word@www.example.com/secret/page.html')
            expect(open(uri).read).to eq('aaa')
          end
        end
      end

      describe 'given proxy' do
        it 'original_open_http receives the correct proxy arguments' do
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

describe URI::FTP do
  let(:ftp) { double(:ftp) }

  describe 'password includes ":"' do
    context 'when the arguments is String(likely URI)' do
      it 'logins with user and password' do
        allow(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:connect).with('ftp.example.com', 21)
        expect(ftp).to receive(:passive=).with(true)
        expect(ftp).to receive(:login).with('user', 'pass:word')
        expect(ftp).to receive(:retrbinary).with("RETR test.txt", 4096)
        expect(ftp).to receive(:close)
        open('ftp://user:pass:word@ftp.example.com/test.txt')
      end
    end

    context 'when the arguments is URI::FTP' do
      it 'logins with user and password' do
        allow(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:connect).with('ftp.example.com', 21)
        expect(ftp).to receive(:passive=).with(true)
        expect(ftp).to receive(:login).with('user', 'pa:ss:wo:rd')
        expect(ftp).to receive(:retrbinary).with("RETR test.txt", 4096)
        expect(ftp).to receive(:close)

        uri = URI.parse('ftp://user:pa:ss:wo:rd@ftp.example.com/test.txt')
        open(uri)
      end
    end
  end

  describe 'password does not include ":"' do
    context 'when the arguments is String(likely URI)' do
      it 'logins with user and password' do
        allow(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:connect).with('ftp.example.com', 21)
        expect(ftp).to receive(:passive=).with(true)
        expect(ftp).to receive(:login).with('user', 'password')
        expect(ftp).to receive(:retrbinary).with("RETR test.txt", 4096)
        expect(ftp).to receive(:close)
        open('ftp://user:password@ftp.example.com/test.txt')
      end
    end

    context 'when the arguments is URI::FTP' do
      it 'logins with user and password' do
        allow(Net::FTP).to receive(:new).and_return(ftp)
        expect(ftp).to receive(:connect).with('ftp.example.com', 21)
        expect(ftp).to receive(:passive=).with(true)
        expect(ftp).to receive(:login).with('user', 'password')
        expect(ftp).to receive(:retrbinary).with("RETR test.txt", 4096)
        expect(ftp).to receive(:close)

        uri = URI.parse('ftp://user:password@ftp.example.com/test.txt')
        open(uri)
      end
    end
  end
end
