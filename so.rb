# frozen_string_literal: true

require_relative 'file_manager'
require_relative 'process_manager'
require_relative 'memory_manager'

# Fila de Escalonamento
real_time_process = []
user_process = []
priority1_process = []
priority2_process = []
priority3_process = []

CREATE = '0'
DELETE = '1'

# Memory - 1024 total - 64 real-time - 960 user
$memory = Array.new(1024)

# puts ARGV[0]

# Read Process file

File.open("procesu.txt", "r").each_line do |line|
  process_info = line.split(', ').map(&:to_i)
  process = ProcessCall.new(*process_info)
  MemoryManager.allocate_process process
  ProcessManager.ready_processes << process
  process.log
end
# puts ProcessManager.ready_processes
# puts $memory

# Read operations file

operations = IO.readlines('tesuto.txt').map(&:chomp)

# Set disk size
$disk = Array.new(operations.shift.to_i, 0)
# puts disk

occupied_segment_number = operations.shift.to_i

occupied_segment_number.times do
  segment = operations.shift.split(', ')
  segment_name, first_block, block_count = segment
  # Operacao de alocacao de disco
  FileManager.initialize_disk segment_name, first_block, block_count
end
# puts $disk

# operacoes efetuadas pelo sistema de arquivo
operations.each do |operation_info|
  operation = operation_info.split(', ')
  pid, opcode, file_name = operation

  if opcode == CREATE
    created_blocks_count, process_operation = operation[3..-1]
    puts created_blocks_count, process_operation
  elsif opcode == DELETE
    process_operation = operation[3..-1]
    puts process_operation
  end
  puts '------------'
  # executar processos
end
