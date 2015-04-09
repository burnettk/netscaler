require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'netscaler'
require 'netscaler/mock_adapter'

describe Netscaler::Server do
  connection = Netscaler::Connection.new 'hostname'=> 'foo', 'password' => 'bar', 'username'=> 'bar'
  connection.adapter = Netscaler::MockAdapter.new :body => '{ "errorcode": 0, "message": "Done" }'

  context 'when adding a new server' do
    it 'a name is required' do
      expect {
        connection.servers.add({'ipaddress'=>'123.123.123.123'})
      }.to raise_error(ArgumentError, /name/)
    end

    it 'an ipaddress is required' do
      expect {
        connection.servers.add({'name'=>'hostname'})
      }.to raise_error(ArgumentError, /ipaddress/)
    end

    it 'returns a Hash object if all necessary args are supplied' do
      result = connection.servers.add :name => 'foo', :domain => 'foo.bar.com'
      expect(result).to be_kind_of(Hash)
    end
  end

  context 'when removing a server' do
    it ':server is required' do
      expect {
        connection.servers.remove({'ipaddress'=>'123.123.123.123'})
      }.to raise_error(ArgumentError, /server/)
    end

    it 'returns a Hash object if all necessary args are supplied' do
      result = connection.servers.remove :server => 'foo'
      expect(result).to be_kind_of(Hash)
    end
  end

  %w(enable disable).each do |toggle_action|
    context "when running server.#{toggle_action}" do

      it ':server is required' do
        expect {
          connection.servers.send(toggle_action, nil)
        }.to raise_error(ArgumentError, /null/)
      end

      it 'returns a hash if all necesssary args are supplied' do
        result = connection.servers.send(toggle_action, :server => 'foo')
        expect(result).to be_kind_of(Hash)
      end

    end
  end

  context 'when showing bindings for a server' do
    it ':server is required' do
      expect {
        connection.servers.show_bindings({})
      }.to raise_error(ArgumentError, /server/)
    end

    it 'returns a Hash object if all necessary args are supplied' do
      result = connection.servers.show_bindings :server => 'foo'
      expect(result).to be_kind_of(Hash)
    end
  end

  context 'when showing a server or servers' do
    it ':server is required if arguments are specified' do
      expect {
        connection.servers.show_bindings({something: 'notcool'})
      }.to raise_error(ArgumentError, /server/)
    end

    it 'returns a Hash object if server arg supplied' do
      result = connection.servers.show_bindings :server => 'foo'
      expect(result).to be_kind_of(Hash)
    end

    it 'returns a Hash object if no args supplied since it then returns all servers' do
      result = connection.servers.show_bindings :server => 'foo'
      expect(result).to be_kind_of(Hash)
    end
  end
end
