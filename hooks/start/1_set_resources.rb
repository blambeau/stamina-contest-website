kernel = Waw::kernel
kernel.resources.send(:add_resource, :grid_tools, ::WebStamina::GridTools.new(nil))
