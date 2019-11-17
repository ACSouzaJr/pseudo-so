# E o gerenciador de arquivos deve permitir que os processos possam criar e deletar arquivos, de acordo com o modelo de alocação determinado.

# frozen_string_literal: true

CREATE = '0'
DELETE = '1'

class DiskFile
  attr_reader :name, :first_block, :block_count, :owner
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
      @disk[offset.to_i..(offset.to_i + block_count.to_i) - 1] = [file_name] * block_count.to_i
      # print_disk
      @all_files[file_name] = DiskFile.new(file_name, offset.to_i, block_count.to_i, nil)
    end

    # puts @all_files

    @instructions = []
    # operacoes efetuadas pelo sistema de arquivo
    operations.each do |operation_info|
      operation = operation_info.split(', ')
      pid, opcode, file_name = operation

      @instructions << {
        pid: pid.to_i,
        opcode: opcode,
        file_name: file_name,
        blocks_count: opcode == '0' ? operation[3].to_i : nil,
        process_operation: operation.last.to_i
      }
    end
    # puts @instructions
  end

  def create_file(pid, file_name, block_count)
    # posição inicial
    offset = 0
    # espaço disponível
    allocable_files = 0

    # Procura se o arquivo já existe
    if @disk.include? file_name
      puts 'O arquivo não pode ser criado porque já está na memória'
      return
    end

    # Localiza espaco disponivel com First Fit e armazena
    #
    @disk.length.times do |i|
      block = @disk[i]
      # puts block
      # Se o bloco estiver vazio
      if block == 0
        allocable_files += 1
        # Se o tamanho disponível for suficiente
        if allocable_files == block_count.to_i
          #6-2+1
          offset = i - allocable_files + 1
          @disk[offset..(offset + allocable_files) - 1] = [file_name] * block_count.to_i
          @all_files[file_name] = DiskFile.new(file_name, offset, block_count.to_i, pid.to_i)
          return puts "O processo #{pid} criou o arquivo #{file_name} (blocos #{(offset..block_count).to_a.to_s})"
        end
      else
        allocable_files = 0
      end
    end
    puts "O processo #{pid} nao criou o arquivo #{file_name} (Sem espaco livre)"
  end

  def delete_file(process, file_name)
    return puts "Arquivo #{file_name} não pode ser deletado porque no ecxiste em memoria." unless @all_files.key? file_name

    file = @all_files[file_name]
    return puts "Processo #{process.pid} não tem permissão para deletar o arquivo #{file_name}" unless file.owner == process.pid || process.real_time?
    # puts file.block_count
    @disk[file.first_block..(file.block_count + file.first_block) - 1] = [0] * file.block_count
    puts "O processo #{process.pid} deletou o arquivo #{file_name}"
  end

  def execute(process)
    instruction = @instructions.select { |inst| inst[:pid] == process.pid && process.pc == inst[:process_operation] }.first
    
    if instruction.nil?
      return puts "\tP#{process.pid} instruction #{process.pc} - CPU" 
    end
    puts "\tP#{process.pid} instruction #{instruction[:process_operation]}"
    if instruction[:opcode] == CREATE
      create_file(instruction[:pid], instruction[:file_name], instruction[:blocks_count])
    elsif instruction[:opcode] == DELETE
      delete_file(process, instruction[:file_name])
    end
    print_disk
  end

  def print_disk
    print "\n"
    print "| "
    @disk.each { |file| print "#{file} | " }
    print "\n"
  end
end
