# O gerenciador de processos deve ser capaz de agrupar os processos em quatro níveis de prioridades

# frozen_string_literal: true

class ProcessCall
  @@pid_count = 0
  attr_accessor :initialization_time, :priority, :cpu_time, :block_count, :printer, :scanner, :modem, :disk_number, :pid, :offset
  
  def initialize(initialization_time, priority, cpu_time, block_count, printer, scanner, modem, driver)
    @initialization_time = initialization_time
    @priority = priority
    @cpu_time = cpu_time
    @block_count = block_count
    @printer = printer
    @scanner = scanner
    @modem = modem
    @driver = driver # disk_number
    @offset = 0
    @pid = @@pid_count
    @@pid_count += 1
  end

  def log
    puts "\tPID: #{@pid}\n" \
         "\toffset: #{@offset}\n" \
         "\tblocks: #{@block_count}\n" \
         "\tpriority: #{@priority}\n" \
         "\ttime: #{@cpu_time}\n" \
         "\tprinters: #{@printer}\n" \
         "\tscanners: #{@scanner}\n" \
         "\tmodems: #{@modem}\n" \
         "\tdrivers: #{@driver}\n\n"
  end
  

  def user?
    @priority.positive?
  end

  def real_time?
    @priority.zero?
  end
end

class ProcessManager
  def self.ready_processes
    @@ready_processes ||= []
  end
end