module RubySugar

  class Client

    def initialize(user_name,password,url,hashed_pass=false)
        unless hashed_pass
          @credentials = { "user_name" => user_name,"password" => Digest::MD5.hexdigest(password) }
        else
          @credentials = { "user_name" => user_name,"password" => password }
        end
        unless url.index('/soap.php?wsdl')
          @url = url[url.length-1,1]=='/' ? url+'soap.php?wsdl' : url+'/soap.php?wsdl'
        else
          @url = url
        end
    end

    def connect
      begin
        #Connect to the Sugar CRM WSDL and build our methods in Ruby
        puts 'Loading SugarCRM WSDL...'
        @ws_proxy = SOAP::WSDLDriverFactory.new(@url).create_rpc_driver
        puts 'SugarCRM WDSL loaded...'
        unless @url.index('https').nil?
          @ws_proxy.options['protocol.http.ssl_config.verify_mode'] = OpenSSL::SSL::VERIFY_NONE
        end
      rescue => err
        raise "Error connecting to SugarCRM"
      end
    end

    def login
      attempt = 0
      begin
        attempt += 1
        #Connect to the Sugar CRM WSDL and build our methods in Ruby
        connect
        puts 'Attempting to login to SugarCRM...'
        @session = @ws_proxy.login(@credentials, nil)
        if @session.error.number.to_i > 0
          raise "Login failed"
        end
      rescue => err
        #let's try to login again, just for good measure
        retry if attempt <= 3
        raise "Login failed"
        @session = nil
      end

      return @session
    end

    def validate_session
      unless @session
        login
      end
      @session.nil? ? login : @session
    end

    def user_id
      begin
        validate_session
        result = @ws_proxy.get_user_id(@session['id'])
        return result
      rescue => err
        puts err
      end
    end

    def logout
      begin
        @ws_proxy.logout(@session['id'])
      rescue => err
        puts err
      end
    end

    def set_entry(mod,data)
      begin
        validate_session
        result = @ws_proxy.set_entry(@session['id'], mod, data)
        return result
      rescue => err
        puts err
      end
    end

    def get_available_modules
      begin
        validate_session
        result = @ws_proxy.get_available_modules(@session['id'])
        modules = Array.new
        result.modules.each {|r| modules << r}
        return modules
      rescue => err
        puts err
      end
    end

    def get_relationships(mod,id,rmod,rmod_query=nil,deleted=0)
      begin
        validate_session
        result = @ws_proxy.get_relationships(@session['id'], mod, id, rmod,rmod_query,deleted)
        return result
      rescue => err
        puts err
      end
    end

    def set_relationship(data)
      begin
        validate_session
        result = @ws_proxy.set_relationship(@session['id'], data)
        return result
      rescue => err
        puts err
      end
    end

    def get_server_version
      begin
        validate_session
        result = @ws_proxy.get_server_version
        return result
      rescue => err
        puts err
      end
    end

    def get_entry_list(mod,query=nil,order=nil,offset=0,fields=nil,results=nil,deleted=0)
      begin
        #Array get_entry_list( String $session, String $module_name, String $query, String $order_by, String $offset, Array $select_fields, String $max_results, Number $deleted  )
        validate_session
        results = @ws_proxy.get_entry_list(@session['id'],mod,query,order,offset,fields,results,deleted)
        entries = Array.new
        results.entry_list.each do |result|
          entry = Array.new
          result.name_value_list.each do |e|
            e = {:name=>e.name,:value=>e.value}
            entry << e
          end
          entries << entry
        end
        return entries
      rescue => err
        puts err
      end
    end

    def get_entries_count(mod,query=nil,deleted=0)
      begin
        validate_session
        result = @ws_proxy.get_entries_count(@session['id'],mod,query,deleted)
        return result
      rescue => err
        puts err
      end
    end

    def get_entry(mod,id,fields=[])
      begin
        validate_session
        result = @ws_proxy.get_entry(@session['id'],mod,id,fields)
        entry = Array.new
        result.entry_list.each do |r|
          r.name_value_list.each do |re|
            e = {:name=>re.name,:value=>re.value}
            entry << e
          end
        end
        return entry
      rescue => err
        puts err
      end
    end

    def get_module_fields(mod)
      begin
        #Array get_module_fields( String $session, String $module_name  )
        validate_session
        results = @ws_proxy.get_module_fields(@session['id'],mod)
        fields = Array.new
        results.module_fields.each do |result|
           field = ModuleField.new({
              :name => result.name,
              :type => result.type,
              :label => result.label,
              :required => result.required,
              :options => result.options
            })
            fields << field
       end
        return fields
      rescue => err
        puts err
      end
    end
    
  end
  
end
