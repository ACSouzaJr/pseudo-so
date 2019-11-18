# O gerenciador de processos deve ser capaz de agrupar os processos em quatro níveis de prioridades

# frozen_string_literal: true

class ProcessCall
  @@pid_count = 0
  attr_accessor :initialization_time, :priority, :cpu_time, :block_count, :printer, :scanner, :modem, :driver, :pid, :offset, :pc
  
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
    @pc = 0
  end

  def dispatcher
    puts "\n dispatcher =>"
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
  attr_accessor :ready_processes, :process_running
  attr_reader :real_time_process, :user_process, :priority1_process, :priority2_process, :priority3_process

  def initialize(process_file_name, memory_manager)
    # Fila de Escalonamento
    @ready_processes = []
    @real_time_process = []
    @user_process = []
    @priority1_process = []
    @priority2_process = []
    @priority3_process = []
    @process_running = nil

    # Read Process file
    File.open(process_file_name, "r").each_line do |line|
      process_info = line.split(', ').map(&:to_i)
      process = ProcessCall.new(*process_info)
      memory_manager.allocate_process process
      @ready_processes << process
    end
  end

  def queue_empty?
    @ready_processes.empty? && @real_time_process.empty? && @user_process.empty? && @priority1_process.empty? && @priority2_process.empty? && @priority3_process.empty?
  end

  def schedule
    return if @ready_processes.empty?

    @ready_processes.sort_by(&:priority)
    if @ready_processes.first.real_time? && @real_time_process.length < 1000
      @real_time_process << @ready_processes.shift
    elsif @ready_processes.first.user? && @user_process.length < 1000
      @user_process << @ready_processes.shift
    end
  end

  def schedule_user_process
    return if @user_process.empty?

    if @user_process.first.priority == 1 && @user_process.length < 1000
      @priority1_process << @user_process.shift
    elsif @user_process.first.priority == 2 && @user_process.length < 1000
      @priority2_process << @user_process.shift
    elsif @user_process.first.priority == 3 && @user_process.length < 1000
      @priority3_process << @user_process.shift
    end
  end
end
