
module Vagrant
  module Notify
    module Action
      module Windows
        class ProcessInfo
          def self.queryProcess(pid)
            return false unless pid =~ /\A\d+\z/
            result = `c\:/Windows/System32/wbem/WMIC.exe process where \"ProcessID = '#{pid}'\" get ProcessID,Commandline /format:list 2>nul`
            querypid = false
            result.split(/\r?\n/).each do |line|
              next if line =~ /^\s*$/
              if line =~ /ProcessId=(\d+)/i
                  querypid = $1.to_i
              end
            end
            return querypid
          end 
        end
      end
    end
  end
end