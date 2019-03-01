require_relative 'dm_stack'

module Pf
  module Stack
    class DmCache
      include DmStack

      def initialize(args)
        @name      = args.fetch("Name")
        @meta      = args.fetch_path("Meta")
        @cache     = args.fetch_path("Cache")
        @backend   = args.fetch_path("Backend")
        @size      = args.fetch_size("Size", @backend)
        @bs        = args.fetch("BlockSize", 128)
        @feature   = args.fetch("Feature", "writeback")
        @policy    = args.fetch("Policy", "mq")
        @seq_thres = args["SequentialThreshold"]
        @ran_thres = args["RandomThreshold"]

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        feature_argc = 1
        policy_args = []
        policy_args << "sequential_threshold" << @seq_thres if @seq_thres
        policy_args << "random_threshold"     << @ran_thres if @ran_thres
        policy_args.unshift(policy_args.size)
        policy_args = policy_args.join(" ")

        DmStack.create(@name, "0 #{@size} cache #{@meta} #{@cache} #{@backend} #{@bs} #{feature_argc} #{@feature} #{@policy} #{policy_args}")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
