require 'chefspec'
require 'chefspec/berkshelf'

describe 'sc-mongodb::mms_monitoring_agent' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu') do |n|
      n['mongodb']['mms_agent']['api_key'] = 'strange key'
    end
  end

  it 'package install the mms_monitoring_agent' do
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('mongodb-mms-monitoring-agent')
    expect(chef_run).to render_file('/etc/mongodb-mms/monitoring-agent.config').with_content(/.*=strange key/)
    resource = chef_run.template('/etc/mongodb-mms/monitoring-agent.config')
    expect(resource).to notify('service[mongodb-mms-monitoring-agent]').to(:restart).delayed
  end
end
