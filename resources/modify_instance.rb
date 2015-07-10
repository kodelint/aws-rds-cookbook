actions [:modify]
default_action :create

attribute :id, kind_of: [String, NilClass], default: nil, name_attribute: true
attribute :aws_access_key, kind_of: [String, NilClass], default: nil
attribute :aws_secret_access_key, kind_of: [String, NilClass], default: nil
attribute :allocated_storage, kind_of: [Integer, NilClass], default: nil
attribute :allow_major_version_upgrade, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :apply_immediately, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :auto_minor_version_upgrade, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :backup_retention_period, kind_of: [Integer, NilClass], default: nil
attribute :db_instance_class, kind_of: [String, NilClass], default: nil
attribute :db_instance_identifier, kind_of: [String, NilClass], default: nil
attribute :db_parameter_group_name, kind_of: [String, NilClass], default: nil
attribute :db_security_groups, kind_of: [Array, NilClass], default: nil
attribute :engine_version, kind_of: [String, NilClass], default: nil
attribute :iops, kind_of: [Integer, NilClass], default: nil
attribute :master_user_password, kind_of: [String, NilClass], default: nil
attribute :multi_az, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :new_db_instance_identifier, kind_of: [String, NilClass], default: nil
attribute :option_group_name, kind_of: [String, NilClass], default: nil
attribute :preferred_backup_window, kind_of: [String, NilClass], default: nil
attribute :preferred_maintenance_window, kind_of: [String, NilClass], default: nil
attribute :storage_type, kind_of: [String, NilClass], default: nil
attribute :vpc_security_group_ids, kind_of: [Array, NilClass], default: nil
attribute :tde_credential_arn, kind_of: [String, NilClass], default: nil
attribute :tde_credential_password, kind_of: [String, NilClass], default: nil

attr_accessor :exists

# UNUSED ATTRIBUTES FOR INSTANCE MODIFICATIONS. DO NOT MODIFY OR SET IN RECIPE. NECESSARY FOR COMPATIBILITY WITH Overclock::Aws::RDS#serialize_attrs.

attribute :db_subnet_group_name, kind_of: [String, NilClass], default: nil
attribute :character_set_name, kind_of: NilClass, default: nil
attribute :db_name, kind_of: NilClass, default: nil
attribute :db_subnet_group_name, kind_of: NilClass, default: nil
attribute :engine, kind_of: NilClass, default: nil
attribute :license_model, kind_of: NilClass, default: nil
attribute :master_username, kind_of: NilClass, default: nil
attribute :skip_final_snapshot, kind_of: NilClass, default: nil
attribute :snapshot_id, kind_of: NilClass default: nil
