# frozen_string_literal: true

require_relative 'file_manager'
require_relative 'process_manager'
require_relative 'memory_manager'

# puts ARGV[0]

# initialize processes
memory_manager = MemoryManager.new
process_manager = ProcessManager.new(memory_manager)
file_manager = FileManager.new

# file_manager.execute

# Sort processes on ready order
process_manager.ready_processes.sort_by(&:initialization_time)

# tempo de inicialização começa em 0
tempo = 0

until process_manager.queue_empty? do
	# Verifica se existem processos em estado de pronto
	unless process_manager.ready_processes.empty?
		#Escalona processos do tempo de chegada = tempo
		if process_manager.ready_processes.first.initialization_time == tempo
			process_manager.schedule # real time ou usuário
			process_manager.schedule_user_process # usuário 1, 2 ou 3
		end
	end
  #Escalona processos da fila de usuario para as filas de prioridade
    
    # Seleciona processo para executar
    if process_manager.process_running.nil?
      if !process_manager.real_time_process.empty?
        process_manager.process_running = process_manager.real_time_process.shift
        elsif !process_manager.priority1_process.empty?
					process_manager.process_running = process_manager.priority1_process.shift
        elsif !process_manager.priority2_process.empty?
					process_manager.process_running = process_manager.priority2_process.shift
        elsif !process_manager.priority3_process.empty?
					process_manager.process_running = process_manager.priority3_process.shift
      end
    end

  # Executa Processo
  unless process_manager.process_running.nil?
		#Decrementa tempo restante e aumenta o numero de instrucoes rodadas
		process_manager.process_running.cpu_time -= 1
        # process_manager.process_running['execucoes'] += 1
        
		# Mostra Saida
		# logger.executa(process_manager.process_running)

		# Após execucação do processo
		# Processo é retirado da memória -> libera recursos ao final de seu tempo de CPU
		if process_manager.process_running.cpu_time == 0
			file_manager.execute(process_manager.process_running)
			# io.libera(process_manager.process_running)
			memory_manager.deallocate_process(process_manager.process_running)
			process_manager.process_running = nil
		# Quantum = 1 -> troca constante
		elsif process_manager.process_running.user?
			if process_manager.process_running.priority == 1
				process_manager.prioridade_1.append(process_manager.process_running)
			elsif process_manager.process_running.priority == 2
				process_manager.prioridade_2.append(process_manager.process_running)
			elsif process_manager.process_running.priority == 3
				process_manager.prioridade_3.append(process_manager.process_running)
				process_manager.process_running = nil
			end
		end
	end
	tempo += 1
end
