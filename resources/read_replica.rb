actions [:create, :delete]
default_action :create

attribute :id, kind_of: String, name_attribute: true
attribute :aws_access_key, kind_of: String
attribute :aws_secret_access_key, kind_of: String
attribute :auto_minor_version_upgrade, kind_of: [TrueClass, FalseClass], default: true
attribute :availability_zone, kind_of: String
attribute :db_instance_class, kind_of: String, required: true
attribute :db_instance_identifier, kind_of: String
attribute :db_parameter_group_name, kind_of: String
attribute :iops, kind_of: Integer
attribute :option_group_name, kind_of: String
attribute :port, kind_of: Integer
attribute :publicly_accessible, kind_of: [TrueClass, FalseClass], default: false
attribute :source_db_instance_identifier, kind_of: String, required: true
attribute :storage_type, kind_of: String, default: 'gp2'
attribute :tags, kind_of: Array

attr_accessor :exists

# UNUSED ATTRIBUTES FOR READ REPLICAS. DO NOT MODIFY OR SET IN RECIPE. NECESSARY FOR COMPATIBILITY WITH Overclock::Aws::RDS#serialize_attrs.

attribute :allocated_storage, kind_of: NilClass, default: nil
attribute :backup_retention_period, kind_of: NilClass, default: nil
attribute :character_set_name, kind_of: NilClass, default: nil
attribute :db_name, kind_of: NilClass, default: nil
attribute :db_security_groups, kind_of: NilClass, default: nil
attribute :db_subnet_group_name, kind_of: NilClass, default: nil
attribute :engine, kind_of: NilClass, default: nil
attribute :engine_version, kind_of: NilClass, default: nil
attribute :license_model, kind_of: NilClass, default: nil
attribute :master_user_password, kind_of: NilClass, default: nil
attribute :master_username, kind_of: NilClass, default: nil
attribute :multi_az, kind_of: NilClass, default: nil
attribute :preferred_backup_window, kind_of: NilClass, default: nil
attribute :preferred_maintenance_window, kind_of: NilClass, default: nil
attribute :region, kind_of: [String, NilClass], default: nil
attribute :skip_final_snapshot, kind_of: NilClass, default: nil
attribute :snapshot_id, kind_of: NilClass, default: nil
attribute :tde_credential_arn, kind_of: NilClass, default: nil
attribute :tde_credential_password, kind_of: NilClass, default: nil
attribute :vpc_security_group_ids, kind_of: NilClass, default: nil
