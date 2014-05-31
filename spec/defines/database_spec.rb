require 'spec_helper'

describe 'duplicity_postgresql::database' do
  let(:title) { 'example' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:dump_file) { '/var/backups/postgresql/example.sql.gz' }

  describe 'by default' do
    let(:params) { {:profile => 'profile'} }

    it { should contain_duplicity__file(dump_file).with(
        'ensure'  => 'present',
        'profile' => 'profile'
      ) 
    }
  end

  describe 'should accept ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_duplicity__file(dump_file).with_ensure('absent') }
  end

  describe 'should not accept invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /ensure/)
    }
  end

  describe 'should not accept missing profile' do
    let(:params) { {:profile => ''} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /profile/)
    }
  end
end
