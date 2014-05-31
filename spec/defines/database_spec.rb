require 'spec_helper'

describe 'duplicity_postgresql::database' do
  let(:title) { 'example' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:dump_script) { '/usr/local/sbin/dump-postgresql-database.sh' }
  let(:dump_file) { '/var/backups/postgresql/example.sql.gz' }

  describe 'by default' do
    let(:params) { {} }

    specify { should contain_duplicity__profile_exec_before('backup/postgresql/example').with(
        'ensure'  => 'present',
        'profile' => 'backup',
        'content' => "#{dump_script} example"
      )
    }
    specify { should contain_duplicity__file(dump_file).with(
        'ensure'  => 'present',
        'profile' => 'backup'
      ) 
    }
  end

  describe 'should accept ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_duplicity__profile_exec_before('backup/postgresql/example').with_ensure('absent') }
    specify { should contain_duplicity__file(dump_file).with_ensure('absent') }
  end

  describe 'should not accept invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /ensure/)
    }
  end

  describe 'with profile => system' do
    let(:params) { {:profile => 'system'} }

    specify {
      should contain_duplicity__profile_exec_before('system/postgresql/example').with(
        'ensure'  => 'present',
        'profile' => 'system',
        'content' => "#{dump_script} example"
      )
    }
  end

  describe 'should not accept missing profile' do
    let(:params) { {:profile => ''} }

    specify {
      expect { should contain_file(dump_file) }.to raise_error(Puppet::Error, /profile/)
    }
  end
end
