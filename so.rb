# frozen_string_literal: true

require_relative 'file_manager'
require_relative 'process_manager'
require_relative 'memory_manager'
require_relative 'resource_manager'

# Finaliza programa se nao possui arquivos de entrada
return unless ARGV[0] && ARGV[1]

# Instancia gerenciadores do so
memory_manager = MemoryManager.new
process_manager = ProcessManager.new(ARGV[0], memory_manager)
file_manager = FileManager.new(ARGV[1])
resource_manager = ResourcesManager.new

# Ordena processos pelo tempo de chegada na fila de pronto
process_manager.ready_processes.sort_by(&:initialization_time)

# tempo de inicialização começa em 0
cpu_clock = 0

until process_manager.queue_empty? && process_manager.process_running.nil?
  # Verifica se existem processos em estado de pronto
  unless process_manager.ready_processes.empty?
    # Escalona processos do tempo de chegada = clock
    if process_manager.ready_processes.first.initialization_time == cpu_clock
      process_manager.schedule # real time ou usuário
      process_manager.schedule_user_process # usuário 1, 2 ou 3
    end
  end
  # Escalona processos da fila de usuario para as filas de prioridade

  # Seleciona processo para executar
  if process_manager.process_running.nil?
    if !process_manager.real_time_process.empty?
      process_manager.process_running = process_manager.real_time_process.shift
      process_manager.process_running.dispatcher
    elsif !process_manager.priority1_process.empty?
      # Verifica se é possivel alocar io, caso nao seja volta para o inicio da fila
      unless resource_manager.allocate_io(process_manager.priority1_process.first)
        process_manager.priority1_process << process_manager.priority1_process.shift
      end
      process_manager.process_running = process_manager.priority1_process.shift
      process_manager.process_running.dispatcher
    elsif !process_manager.priority2_process.empty?
      # Verifica se é possivel alocar io, caso nao seja volta para o inicio da fila
      unless resource_manager.allocate_io(process_manager.priority2_process.first)
        process_manager.priority2_process << process_manager.priority2_process.shift
      end
      process_manager.process_running = process_manager.priority2_process.shift
      process_manager.process_running.dispatcher
    elsif !process_manager.priority3_process.empty?
      # Verifica se é possivel alocar io, caso nao seja volta para o inicio da fila
      unless resource_manager.allocate_io(process_manager.priority3_process.first)
        process_manager.priority3_process << process_manager.priority3_process.shift
      end
      process_manager.process_running = process_manager.priority3_process.shift
      process_manager.process_running.dispatcher
    end
  end

  # Executa Processo
  unless process_manager.process_running.nil?
    # Decrementa tempo restante e aumenta o numero de instrucoes rodadas
    process_manager.process_running.cpu_time -= 1

    # Executa instrução correspondente ao uso da cpu
    file_manager.execute(process_manager.process_running)
    process_manager.process_running.pc += 1

    # Após execucação do processo
    # Processo é retirado da memória -> libera recursos ao final de seu tempo de CPU
    if process_manager.process_running.cpu_time == 0
      resource_manager.free_io(process_manager.process_running)
      memory_manager.deallocate_process(process_manager.process_running)
      process_manager.process_running = nil
    end
  end
  # Quantum = 1
  cpu_clock += 1
end
