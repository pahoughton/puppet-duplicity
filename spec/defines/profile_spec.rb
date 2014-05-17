require 'spec_helper'

describe 'duplicity::profile' do
  let(:title) { 'default' }
  let(:default_config_file) { '/etc/duply/default/conf' }
  let(:a_source) { '/path/of/source' }
  let(:a_target) { 'http://example.com' }

  describe 'by default' do
    let(:params) { {:source => a_source, :target => a_target} }

    it { should contain_file('/etc/duply/default').with_ensure('directory') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('file') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('file') }
    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='disabled'$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_PW=''$/) }
    it { should contain_file(default_config_file).with_content(/^GPG_OPTS=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_USER=''$/) }
    it { should contain_file(default_config_file).with_content(/^TARGET_PASS=''$/) }
    it { should contain_file(default_config_file).with_content(/^#MAX_FULLBKP_AGE=.*$/) }
    it { should contain_file(default_config_file).with_content(/^#VOLSIZE=.*$/) }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file('/etc/duply/default').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/conf').with_ensure('absent') }
    it { should contain_file('/etc/duply/default/exclude').with_ensure('absent') }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid gpg_encryption_keys' do
    let(:params) { {:gpg_encryption_keys => 'foobar', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /gpg_encryption_keys/)
    end
  end

  describe 'with gpg_encryption_keys => [key1]' do
    let(:params) { {:gpg_encryption_keys => ['key1'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1'$/) }
  end

  describe 'with gpg_encryption_keys => [key1,key2]' do
    let(:params) { {:gpg_encryption_keys => ['key1', 'key2'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEYS_ENC='key1,key2'$/) }
  end

  describe 'with invalid gpg_signing_key' do
    let(:params) { {:gpg_signing_key => 'invalid-key-id', :source => a_source, :target => a_target} }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /signing_key/)
    end
  end

  describe 'with gpg_signing_key => key1' do
    let(:params) { {:gpg_signing_key => 'key1', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_KEY_SIGN='key1'$/) }
  end

  describe 'with gpg_password => secret' do
    let(:params) { {:gpg_password => 'secret', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_PW='secret'$/) }
  end

  describe 'with gpg_options => [--switch]' do
    let(:params) { {:gpg_options => ['--switch'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch'$/) }
  end

  describe 'with gpg_options => [--switch, --key=value]' do
    let(:params) { {:gpg_options => ['--switch', '--key=value'], :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^GPG_OPTS='--switch --key=value'$/) }
  end

  describe 'with empty source' do
    let(:params) { {:source => '', :target => a_target } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /source/)
    end
  end

  describe 'with source => /path/of/source' do
    let(:params) { {:source => '/path/of/source', :target => a_target, } }

    it { should contain_file(default_config_file).with_content(/^SOURCE='\/path\/of\/source'$/) }
  end

  describe 'with empty target' do
    let(:params) { {:target => '', :source => a_source, } }

    it do
      expect { should contain_file(default_config_file) }.to raise_error(Puppet::Error, /target/)
    end
  end

  describe 'with target => http://example.com' do
    let(:params) { {:target => 'http://example.com', :source => a_source, } }

    it { should contain_file(default_config_file).with_content(/^TARGET='http:\/\/example.com'$/) }
  end

  describe 'with target_username => johndoe' do
    let(:params) { {:target_username => 'johndoe', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_USER='johndoe'$/) }
  end

  describe 'with target_password => secret' do
    let(:params) { {:target_password => 'secret', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^TARGET_PASS='secret'$/) }
  end

  describe 'with full_if_older_than => 1M' do
    let(:params) { {:full_if_older_than => '1M', :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^MAX_FULLBKP_AGE=1M$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --full-if-older-than \$MAX_FULLBKP_AGE "$/) }
  end

  describe 'with volsize => 25' do
    let(:params) { {:volsize => 25, :source => a_source, :target => a_target} }

    it { should contain_file(default_config_file).with_content(/^VOLSIZE=25$/) }
    it { should contain_file(default_config_file).with_content(/^DUPL_PARAMS="\$DUPL_PARAMS --volsize \$VOLSIZE "$/) }
  end
end