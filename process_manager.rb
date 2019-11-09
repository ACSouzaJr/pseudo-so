# O gerenciador de processos deve ser capaz de agrupar os processos em quatro níveis de prioridades

# frozen_string_literal: true

class ProcessCall
  @@pid_count = 0
  attr_accessor :initialization_time, :priority, :cpu_time, :block_count, :printer, :scanner, :drivers, :disk_number, :pid, :offset
  
  def initialize(initialization_time, priority, cpu_time, block_count, printer, scanner, drivers, disk_number)
    @initialization_time = initialization_time
    @priority = priority
    @cpu_time = cpu_time
    @block_count = block_count
    @printer = printer
    @scanner = scanner
    @drivers = drivers
    @disk_number = disk_number
    @offset = 0
    @pid = @@pid_count
    @@pid_count += 1
  end

  def user?
    @priority > 0
  end
  def real_time?
    @priority == 0
  end
end

class ProcessManager
  def self.processes
    @@processes ||= []
  end
end