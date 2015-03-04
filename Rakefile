require "active_support/inflector"

task :create_page, :file_name do |t, args|
    args.with_defaults(:file_name => 'index.html.md')
    
    file_name = args[:file_name]
    
    if not file_name =~ /^source\//
        file_name = "source/#{file_name}"
    end
    
    if not File.exists? file_name
        output_name = file_name
        while output_name =~ /\.[a-z]+$/
            output_name = File.basename(output_name, ".*")
        end
        output_name = output_name.humanize
        File.open(file_name, 'w') do |fp|
            fp.write("---\npage_link_name: \"#{output_name}\"\npage_sidebar_widgets:\n- |\n  ### Sample Widget\n\n  Foobar\n---\n\nPage Content Goes Here.")
        end
        
        puts "File #{file_name} has been created."
    else
        puts "File #{file_name} already exists!"
    end
end