# O gerenciador de memória deve garantir que um processo não acesse a região de memória de um outro processo.

# frozen_string_literal: true

MEMORY_REAL_TIME = 64
MEMORY_USER = 960

class MemoryManager
  def self.allocate_process(process)
    memory_start = 0
    memory_end = 1024
    if process.user?
      memory_start = MEMORY_REAL_TIME
    elsif process.real_time?
      memory_end = MEMORY_USER
    end

    if $memory[memory_start..memory_end].count(nil) >= process.block_count
      process.offset = $memory[memory_start..memory_end].index(nil)
      process.block_count.times do
        $memory[$memory[memory_start..memory_end].index(nil)] = process.pid
      end
      process.pid
    end
  end

  def self.deallocate_process(process)
    $memory[process.offset..(process.block_count + process.offset)] = process.block_count * [nil]
  end
end
