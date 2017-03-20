require 'spec_helper'

describe 'role_monitor' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo",
            :monitor_address => "localhost"
          })
        end

        context "role_monitor class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          # classes
          it { is_expected.to contain_class('role_monitor') }
          it { is_expected.to contain_class('profile_base') }

        end
      end
    end
  end
end
