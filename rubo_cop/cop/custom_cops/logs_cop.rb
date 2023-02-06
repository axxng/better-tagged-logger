module RuboCop
  module Cop
    module CustomCops
      class LogsCop < Cop
        MSG = 'Avoid using `p puts logger`, see and use `tagged_logger.rb` instead.'.freeze

        def_node_matcher(:logs?, '{(send _ {:p :puts} _) (send _ :logger)}')

        def on_send(node)
          return unless logs?(node)

          add_offense(node, location: :expression)
        end
      end
    end
  end
end
