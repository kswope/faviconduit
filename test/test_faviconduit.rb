require 'helper'


class TestFaviconduit < Test::Unit::TestCase

  RAILS_ROOT = 'test/rails_root'



  def teardown

    # some tests require a running rails instance, make sure its dead.
    # other tests move favicon.ico around, make sure we put it back
    Dir.chdir RAILS_ROOT do
      system 'kill -9 $(cat tmp/pids/server.pid) 2>/dev/null'
      system "mv public/favicon.ico.off public/favicon.ico 2>/dev/null"
    end

  end


  # testing how Addressable::URI.heuristic_parse behaves, just to be sure.
  def test_uri_parse

    assert_equal('http://a.com',
                 Addressable::URI.heuristic_parse('a.com').to_s)

    assert_equal('http://a.com',
                 Addressable::URI.heuristic_parse('http://a.com').to_s)

    assert_equal('https://a.com',
                 Addressable::URI.heuristic_parse('https://a.com').to_s)

    assert_equal('http://a.com/fav.ico',
                 Addressable::URI.heuristic_parse('http://a.com/fav.ico').to_s)

  end


  # testing how Addressable::URI.join behaves, just to be sure.
  def test_URI_join

    assert_equal('https://a.com/favicon.ico',
                 Addressable::URI.join('https://a.com',
                                       '/favicon.ico').to_s)

    assert_equal('http://a.com/two/favicon.ico',
                 Addressable::URI.join('http://a.com/one',
                                       'http://a.com/two/favicon.ico').to_s)

    assert_equal('http://www.blogger.com/favicon.ico',
                 Addressable::URI.join('http://a.blogger.com',
                                       'http://www.blogger.com/favicon.ico').to_s)


  end


  def test_favicon_getting

    rails_port = 3333
    url = "http://localhost:#{rails_port}/welcome/"

    Dir.chdir RAILS_ROOT do

      puts 'Starting rails server for tests'
      system "rails server -d -p #{rails_port}"
      begin
        open(url)
      rescue Errno::ECONNREFUSED => e
        puts "waiting for rails to boot and respond at #{url}"
        sleep 1
        retry
      end

      assert_raise Faviconduit::MissingFavicon do
        Faviconduit.read(url + 'missing')
      end

      assert_raise Faviconduit::InvalidFavicon do
        Faviconduit.read(url + 'html')
      end

      assert_raise Faviconduit::InvalidFavicon do
        Faviconduit.read(url + 'zero')
      end

      assert Faviconduit.read(url + 'default')
      assert Faviconduit.read(url + 'icon')
      assert Faviconduit.read(url + 'shortcut_icon')

      # hide default favicon.ico
      system "mv public/favicon.ico public/favicon.ico.off"
      assert_raise Faviconduit::MissingFavicon do
        puts Faviconduit.read(url + 'default')
      end
      system "mv public/favicon.ico.off public/favicon.ico"

    end # Dir.chdir

  end # test_favicon_getting

end
