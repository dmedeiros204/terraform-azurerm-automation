title 'terraform vmss  config'

automation_account_id = attribute('automation_account_id')

control 'terraform-azure-01' do
  desc 'azure automation account created'
  describe azure_generic_resource(resource_id: automation_account_id) do
    it { should exist }
    its('location') { should eq 'canadacentral' }
    its('properties.provisioningState') { should cmp 'Succeeded' }
    its('sku.name') { should eq 'Basic' }
  end
end

