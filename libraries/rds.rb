# Copyright (c) 2013 Greg Osuri <gosuri@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'date'

# Overclock module
module Overclock
end

module Overclock::Aws
	# RDS module
	module RDS
		SERIALIZE_ATTRS = [
			:allocated_storage,
			:auto_minor_version_upgrade,
			:availability_zone,
			:backup_retention_period,
			:character_set_name,
			:db_instance_class,
			:db_instance_identifier,
			:db_name,
			:db_parameter_group_name,
			:db_subnet_group_name,
			:db_security_groups,
			:db_subnet_group_name,
			:engine,
			:engine_version,
			:iops,
			:license_model,
			:master_user_password,
			:master_username,
			:multi_az,
			:option_group_name,
			:port,
			:preferred_backup_window,
			:preferred_maintenance_window,
			:publicly_accessible,
			:storage_type,
			:tags,
			:tde_credential_arn,
			:tde_credential_password,
			:vpc_security_group_ids
		]

		DESERIALIZE_ATTRS = [
			:allocated_storage,
			:auto_minor_version_upgrade,
			:backup_retention_period,
			:character_set_name,
			:db_instance_class,
			:db_instance_identifier,
			:db_name,
			:engine,
			:engine_version,
			:iops,
			:license_model,
			:master_username,
			:multi_az,
			:preferred_backup_window,
			:preferred_maintenance_window,
			:endpoint_address
		]

		def instance(id = new_resource.id)
			@instance ||= rds.db_instances[id]
		end

		def rds(key = new_resource.aws_access_key, secret = new_resource.aws_secret_access_key)
			begin
				require 'aws-sdk-v1'
			rescue Exception => e
				Chef::Log.error("#{e}")
			end
			@rds ||= ::AWS::RDS.new(access_key_id: key, secret_access_key: secret, region: region)
		end

		def create_instance(id)
			if @instance = rds.db_instances.create(id, serialize_attrs)
				sleep 5 while (instance.status != 'available')
			end
		end

		def create_read_replica(id, source_db_id)
			options = serialize_attrs.delete_if { |_k, v| v.nil? }
			options[:db_instance_identifier] = id
			options[:source_db_instance_identifier] = source_db_id
			rds.client.create_db_instance_read_replica(options)
			unless (instance.status == 'available')
				sleep 5 while (instance.status != 'available')
			end
		end

		def modify_db_instance(id)
			options = serialize_attrs.delete_if { |_k, v| v.nil? }
			options[:db_instance_identifier] = id
			options[:apply_immediately] = new_resource.apply_immediately
			unless (instance.status == 'available')
				Chef::Log.warn("RDS instance to be modified is not in 'available' state. Retrying at 5 second intervals...")
				Chef::Log.warn("instance.status = #{instance.status}")
				sleep 5 while (instance.status != 'available')
			end
			rds.client.modify_db_instance(options)
		end

		def delete_instance(id, skip_final_snapshot)
			@instance ||= rds.db_instances[id]
			if @instance
				if skip_final_snapshot
					options = {
						skip_final_snapshot: true
					}
				else
					time = Time.now.to_s
					date = DateTime.parse(time).strftime('%Y%m%d-%H%M')
					options = {
						skip_final_snapshot: false,
						final_db_snapshot_identifier: "#{new_resource.id}-#{date}"
					}
				end
				@instance.delete(options)
			end
		end

		def set_node_attrs
			node.override[:aws_rds][new_resource.id] = deserialize_attrs
		end

		def region
			new_resource.region || determine_region
		end

   private

		# Determine the current region or fail gracefully
		def determine_region
			`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | grep -Po "(us|sa|eu|ap)-(north|south)?(east|west)?-[0-9]+"`.strip
		rescue
			new_resource.region
		end

		def serialize_attrs
			SERIALIZE_ATTRS.inject({}) do | result, key |
				if value = new_resource.send(key)
					result[key] = value
				end
				result
			end
		end

		def deserialize_attrs
			DESERIALIZE_ATTRS.inject({}) do |result, attr|
				result[attr] = instance.send(attr)
				result
			end
		end
	end
end
