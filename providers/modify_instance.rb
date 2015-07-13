include Overclock::Aws::RDS

def whyrun_supported?
	true
end

use_inline_resources

action :modify do
	if !(@current_resource.exists)
		Chef::Log.info "#{@new_resource} does not exist - nothing to do."
	else
		converge_by "Modify #{@new_resource}" do
			Chef::Log.info "Modifying #{new_resource}. This could take a few minutes."
			modify_db_instance(@new_resource.id)
			Chef::Log.info "Modified #{@new_resource}"
			set_node_attrs
			new_resource.updated_by_last_action(true)
		end
	end
end

def load_current_resource
	@current_resource = Chef::Resource::AwsRdsModifyInstance.new(new_resource.id)
	@current_resource.exists = instance.exists?
end
