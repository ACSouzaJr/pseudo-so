# E o gerenciador de arquivos deve permitir que os processos possam criar e deletar arquivos, de acordo com o modelo de alocação determinado.

# frozen_string_literal: true

CREATE = '0'
DELETE = '1'

class DiskFile
  def initialize(name, first_block, block_count, owner)
    @name = name
    @first_block = first_block
    @block_count = block_count
    @owner = owner
  end
end

class FileManager
  attr_reader :disk
  def initialize
    # Set disk size
    @all_files = {}

    # Read operations file
    operations = IO.readlines('tesuto.txt').map(&:chomp)

    disk_size = operations.shift.to_i
    @disk = Array.new(disk_size, 0)

    occupied_block_count = operations.shift.to_i
    # Initialize disk
    occupied_block_count.times do
      block = operations.shift.split(', ')
      file_name, offset, block_count = block
      # Operacao de alocacao de disco
      @disk[offset.to_i..(offset.to_i + block_count.to_i)] = [file_name] * block_count.to_i
      @all_files[file_name] = DiskFile.new(file_name, offset.to_i, block_count.to_i, nil)
    end

    # puts @all_files

    # operacoes efetuadas pelo sistema de arquivo
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
  end

  def create_file(pid, file_name, block_count)
    # posição inicial
    offset = 0
    # espaço disponível
    allocable_files = 0

    # Procura se o arquivo já existe
    if @disk.key? file_name
      puts 'O arquivo já está na memória'
    end

    # Localiza espaco disponivel com First Fit e armazena

    @disk.length.times do |i|
      block = @disk[i]
      # Se o bloco estiver vazio
      if block == 0
        allocable_files += 1
        # Se o tamanho disponível for suficiente
        if allocable_files == block_count
          offset = i - allocable_files + 1
          @disk[offset..(offset + allocable_files)] = block_count * [nome]
          @all_files[file_name] = DiskFile.new(file_name, offset, block_count, pid)
          puts 'O processo {} criou o arquivo {} (blocos {})'
        end
      else
        allocable_files = 0
      end
      puts 'O processo {} nao criou o arquivo {} (Sem espaco livre)'
    end
  end

  def delete_file(file_name)
    all_files.key? file_name
    disk[first_block..(block_count + first_block)] = block_count * [0]
  end
end
