require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'barman class' do

  context 'basic setup' do
    # Using puppet_apply as a helper

    it 'should work with no errors' do
      pp = <<-EOF

      include ::epel

      class { 'postgresql':
    		wal_level         => 'hot_standby',
    		max_wal_senders   => '3',
    		wal_keep_segments => '8',
    		version           => '9.6',
    	}

      ->

      class { 'barman':
        require => Class['::epel'],
      }

      barman::backup { 'pgm':
        description => 'postgres master',
        host => '192.168.56.29',
        port => '60901',
        mailto => 'backup_reports@systemadmin.es',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe package($packagename) do
      it { is_expected.to be_installed }
    end

    it "crontab pgm" do
      expect(shell("crontab -l | grep pgm").exit_code).to be_zero
    end

    # /etc/barman/barman.conf
    describe file($barmanconf) do
      it { should be_file }
      its(:content) { should match 'puppet managed file' }
      its(:content) { should match 'configuration_files_directory = /etc/barman.d' }
      its(:content) { should match 'log_file = /var/log/barman/barman.log' }
      its(:content) { should match 'barman_user = barman' }
      its(:content) { should match 'barman_home = /var/lib/barman' }
    end

    # /etc/barman.d/pgm.conf
    describe file($barmanpgm) do
      it { should be_file }
      its(:content) { should match 'puppet managed file' }
      its(:content) { should match '[pgm]' }
      its(:content) { should match 'retention_policy = RECOVERY WINDOW OF 30 days' }
      its(:content) { should match 'host=192.168.56.29' }
      its(:content) { should match 'user=postgres' }
      its(:content) { should match 'port=60901' }
      its(:content) { should match 'description = "postgres master"' }
    end

    # barman list-server | grep pgm
    it "crontab pgm" do
      expect(shell("barman list-server | grep pgm").exit_code).to be_zero
    end

    # barman show-server pgm | grep -i 'active: True'
    it "crontab pgm" do
      expect(shell("barman show-server pgm | grep -i 'active: True'").exit_code).to be_zero
    end

  end
end
