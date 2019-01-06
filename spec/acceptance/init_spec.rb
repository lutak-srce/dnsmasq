require 'spec_helper_acceptance'

describe 'dnsmasq class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = 'include dnsmasq'

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    # do some basic checks
    pkg = 'dnsmasq'
    describe package(pkg) do
      it { is_expected.to be_installed }
    end

    describe service('dnsmasq') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
