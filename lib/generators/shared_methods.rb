module SharedMethods
  def create_or_remove_files(dir, file_name, template_path, **args)
    filter_dir = File.join(dir, name)
    filter_file = File.join(filter_dir, file_name)

    case behavior
    when :invoke
      FileUtils.mkdir_p(filter_dir) unless Dir.exist?(filter_dir)

      return if File.exist?(filter_file)

      if File.exist?(template_path)
        template_content = File.read(template_path)
        processed_content = ERB.new(template_content, **args).result(binding)

        File.write(filter_file, processed_content)
        say_status("create", "  #{filter_file}")
      else
        say_status("error", "  template class not found", :red)
      end
    when :revoke
      if File.exist?(filter_file)
        say_status("remove", "  #{filter_file}", :red)

        FileUtils.rm_rf(filter_file)
        Dir.rmdir(filter_dir) if Dir.exist?(filter_dir) && Dir.empty?(filter_dir)
      else
        say_status("remove", "  not found", :red)
      end
    end
  end
end
