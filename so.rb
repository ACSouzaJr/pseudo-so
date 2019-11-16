# frozen_string_literal: true

require_relative 'file_manager'
require_relative 'process_manager'
require_relative 'memory_manager'

# puts ARGV[0]

# initialize processes
memory_manager = MemoryManager.new
process_manager = ProcessManager.new(memory_manager)
file_manager = FileManager.new

file_manager.execute

# Ordena processos por ordem de chegada
process_manager.ready_processes.sort_by(&:initialization_time)

# alguma coisa.
t = 0
while true
  #Se tiver processo ainda nao processado
  while(process_manager.ready_processes)
    #Escalona processos do tempo de chegada = t
    if(manager.fila_principal[0]['tempo_init'] == t)
      manager.escalona_processo_geral()
    else
      break
    end
  end
  #Escalona processos da fila de usuario para as filas de prioridade
  while(manager.escalona_processo_usuario()):
      pass
  #SE NAO TEM NADA EXECUTANDO(SE TIVER VAI SER TEMPO REAL)
  if(not(manager.em_execucao))
      #Executa tempo real se tiver
      for novo_processo in manager.fila_tempo_real:
          #Tenta salvar na memoria, se tiver espaco
          novo_processo['PID'] = manager.gera_pid()
          offset = memory.salva(novo_processo)
          #Coloca em execucao
          if(offset is not None):
              manager.em_execucao = manager.fila_tempo_real.pop(manager.fila_tempo_real.index(novo_processo))
              manager.em_execucao['offset'] = offset
              logger.dispatch(manager.em_execucao)
              break
          #Nao atribui PID se n conseguir salvar na memoria
          else:
              novo_processo['PID'] = None
              manager.ultimoPID -= 1

      #Se nao tiver tempo real, vai ser despachado processos de usuario
      else:
          # Procura algum processo de prioridade 1 que possa ser executado
          for novo_processo in manager.prioridade_1:
              #Se processo ainda nao esta na memoria(nunca foi executado)
              if novo_processo['offset'] is None:
                  #Ve se pode ser alocado em IO
                  novo_processo['PID'] = manager.gera_pid()
                  if(io.aloca(novo_processo)):
                      offset = memory.salva(novo_processo)
                      novo_processo['offset'] = offset
                      if offset is not None:
                          logger.dispatch(novo_processo)
              offset = novo_processo['offset']
              #Se o processo puder ser executado, carrega para a CPU
              if(offset is not None):
                  manager.em_execucao = manager.prioridade_1.pop(manager.prioridade_1.index(novo_processo))
                  break
              else:
                  novo_processo['PID'] = None
                  manager.ultimoPID -= 1

          # Se nao pode atribuir processos de prioridade 1(falta de processos ou recursos(memoria e io))
          else:
              for novo_processo in manager.prioridade_2:
                  #Se processo ainda nao esta na memoria
                  if novo_processo['offset'] is None:
                      #Ve se pode ser alocado em IO
                      novo_processo['PID'] = manager.gera_pid()
                      if(io.aloca(novo_processo)):
                          offset = memory.salva(novo_processo)
                          novo_processo['offset'] = offset
                          if offset is not None:
                              logger.dispatch(novo_processo)
                  offset = novo_processo['offset']
                  #Se o processo puder ser executado, carrega para a CPU
                  if(offset is not None):
                      manager.em_execucao = manager.prioridade_2.pop(manager.prioridade_2.index(novo_processo))
                      break
                  else:
                      novo_processo['PID'] = None
                      manager.ultimoPID -= 1

              # Se nao pode atribuir processos de prioridade 1 ou 2(falta de processos ou recursos(memoria e io))
              else:
                  for novo_processo in manager.prioridade_3:
                      #Se processo ainda nao esta na memoria
                      if novo_processo['offset'] is None:
                          #Ve se pode ser alocado em IO
                          novo_processo['PID'] = manager.gera_pid()
                          if(io.aloca(novo_processo)):
                              offset = memory.salva(novo_processo)
                              novo_processo['offset'] = offset
                              if offset is not None:
                                  logger.dispatch(novo_processo)
                      offset = novo_processo['offset']
                      #Se o processo puder ser executado, carrega para a CPU
                      if(offset is not None):
                          manager.em_execucao = manager.prioridade_3.pop(manager.prioridade_3.index(novo_processo))
                          break
                      else:
                          novo_processo['PID'] = None
                          manager.ultimoPID -= 1
      if(manager.acabou()):
          #Condicao de saida do programa => Nao tem nenhum processo em nenhuma fila
          #E todos os processos ja chegaram
          break
  # Executa Processo
  if(manager.em_execucao):
      #Decrementa tempo restante e aumenta o numero de instrucoes rodadas
      manager.em_execucao['tempo_processador'] -= 1
      manager.em_execucao['execucoes'] += 1
      #Mostra Saida
      logger.executa(manager.em_execucao)
      #APOS EXECUCAO
      #Remove o processo da memoria e libera recursos SE TIVER ACABADO O TEMPO
      if manager.em_execucao['tempo_processador'] == 0:
          filesystem.opera_processo(manager.em_execucao)
          io.libera(manager.em_execucao)
          memory.mata(manager.em_execucao)
          manager.em_execucao = {}
      #COmo o quantum eh um, processos de usuario sao retirados da CPU em toda iteracao
      elif manager.em_execucao['prioridade'] > 0:
          if manager.em_execucao['prioridade'] == 1:
              manager.prioridade_1.append(manager.em_execucao)
          elif manager.em_execucao['prioridade'] == 2:
              manager.prioridade_2.append(manager.em_execucao)
          elif manager.em_execucao['prioridade'] == 3:
              manager.prioridade_3.append(manager.em_execucao)
          manager.em_execucao = {}
  #Avanca uma unidade de tempo
  t += 1
end

# # Read operations file
# operations = IO.readlines('tesuto.txt').map(&:chomp)

# disk_size = operations.shift.to_i
# occupied_block_count = operations.shift.to_i


# puts file_manager.disk

# # operacoes efetuadas pelo sistema de arquivo
# operations.each do |operation_info|
#   operation = operation_info.split(', ')
#   pid, opcode, file_name = operation

#   if opcode == CREATE
#     created_blocks_count, process_operation = operation[3..-1]
#     puts created_blocks_count, process_operation
#     # FileManager.create_file(pid, file_name, created_blocks_count)
#   elsif opcode == DELETE
#     process_operation = operation[3..-1]
#     puts process_operation
#     # return if ProcessManager.ready_processes[pid.to_i].user?
#     # FileManager.delete_file(file_name)
#   end
#   puts '------------'
#   # executar processos
# end
