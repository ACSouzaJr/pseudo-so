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
  attr_accessor :ready_processes

  def initialize
    # Fila de Escalonamento
    @ready_processes = []
    @real_time_process = []
    @user_process = []
    @priority1_process = []
    @priority2_process = []
    @priority3_process = []
  end

  def schedule
    return if @ready_processes.empty?

    @ready_processes.sort_by(&:priority)
    if @ready_processes.first.real_time?
      @real_time_process << @ready_processes.shift
    elsif @ready_processes.first.user?
      @user_process << @ready_processes.shift
    end
  end

  def schedule_user_process
    return if @user_process.empty?

    if @user_process.first.priority == 1
      @priority1_process << @user_process.shift
    elsif @user_process.first.priority == 2
      @priority2_process << @user_process.shift
    elsif @user_process.first.priority == 3
      @priority3_process << @user_process.shift
    end
  end

  def execute
    # while schedule;
    # while schedule_user_process;
  end
end
