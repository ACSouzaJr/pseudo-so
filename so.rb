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
puts file_manager.disk

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
