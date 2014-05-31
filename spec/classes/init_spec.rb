require 'spec_helper'

describe 'duplicity_postgresql' do
  let(:title) { 'duplicity_postgresql' }
  let(:facts) { {:osfamily => 'Debian'} }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_file('/usr/local/sbin/dump-postgresql-database.sh').with(
        'ensure' => 'file',
        'mode'   => '0755'
      )
    }
    it { should contain_file('/var/backups/postgresql').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600'
      )
    }
  end
end

