# frozen_string_literal: true

require 'trailblazer/operation/validate'

module Pragma
  module Resource
    module Macro
      module Contract
        def self.Validate(name: 'default', **args)
          step = lambda do |input, options|
            Macro.require_skill('Contract::Validate', "contract.#{name}.class", options)

            Trailblazer::Operation::Pipetree::Step.new(
              Trailblazer::Operation::Contract::Validate(**args).first
            ).call(input, options).tap do |result|
              unless result
                options['result.response'] = Pragma::Operation::Response::UnprocessableEntity.new(
                  errors: options["contract.#{name}"].errors.messages
                ).decorate_with(Pragma::Decorator::Error)
              end
            end
          end

          [step, name: "contract.#{name}.validate"]
        end
      end
    end
  end
end
