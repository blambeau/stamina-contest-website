kernel = Waw::kernel
database = ::Rubyrel::connect(kernel.config.database_handler)
database.extend(WebStamina::DatabaseFunctions)
kernel.resources.send(:add_resource, :db, database)
kernel.resources.send(:add_resource, :sequel_db, database.handler)
kernel.resources.send(:add_resource, :grid_tools, ::WebStamina::GridTools.new(database))
