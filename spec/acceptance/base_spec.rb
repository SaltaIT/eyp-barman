require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'barman class' do

  context 'basic setup' do
    # Using puppet_apply as a helper

    it 'should work with no errors' do
      pp = <<-EOF

      class { 'barman': }

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

  end
end
