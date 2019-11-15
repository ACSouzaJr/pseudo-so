# O gerenciador de memória deve garantir que um processo não acesse a região de memória de um outro processo.

# frozen_string_literal: true

MEMORY_REAL_TIME = 64
MEMORY_USER = 960

class MemoryManager

  def initialize
    # Memory - 1024 total - 64 real-time - 960 user
    @memory = Array.new(1024)
  end

  def allocate_process(process)
    memory_start = 0
    memory_end = 1024
    if process.user?
      memory_start = MEMORY_REAL_TIME
    elsif process.real_time?
      memory_end = MEMORY_USER
    end

    if @memory[memory_start..memory_end].count(nil) >= process.block_count
      process.offset = @memory[memory_start..memory_end].index(nil)
      @memory[process.offset..(process.offset + process.block_count)] = [process.pid] * process.block_count
      process.pid
    end
  end

  def deallocate_process(process)
    @memory[process.offset..(process.block_count + process.offset)] = process.block_count * [nil]
  end
end
