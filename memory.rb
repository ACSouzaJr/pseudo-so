# O gerenciador de memória deve garantir que um processo não acesse a região de memória de um outro processo.

# frozen_string_literal: true

MEMORY_REAL_TIME = 64
MEMORY_USER = 960

class MemoryManager
  def allocate_process(process)
    memory_start = 0
    memory_end = 0
    # if process.user?
    #   memory_start = MEMORY_REAL_TIME
    # elsif process.real_time?
    #   memory_end = MEMORY_USER
    # end

    if $memory.count(nil) >= process.block_count
      process.offset = $memory.find(nil)
      process.block_count.times do
        $memory[$memory.find(nil)] = process.pid
      end
    end
  end
end
