# E o gerenciador de arquivos deve permitir que os processos possam criar e deletar arquivos, de acordo com o modelo de alocação determinado.

# frozen_string_literal: true

class DiskFile
  def initialize(name, first_block, block_count, owner)
    @name = name
    @first_block = first_block
    @block_count = block_count
    @owner = owner
  end
end

class FileManager
  def self.initialize_disk(segment_name, first_block, block_count)
    block_count.to_i.times do |offset|
      $disk[first_block.to_i + offset] = segment_name
    end
  end
end
