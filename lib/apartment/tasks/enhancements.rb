# Require this file to append Apartment rake tasks to ActiveRecord db rake tasks
# Enabled by default in the initializer

module Apartment
  class RakeTaskEnhancer

    TASKS = %w(
              db:migrate
              db:migrate:up
              db:migrate:down
              db:migrate:redo
              db:rollback
              db:seed
            )

    PRE_TASKS = %w(
                  db:drop
                )

    # This is a bit convoluted, but helps solve problems when using Apartment within an engine
    # See spec/integration/use_within_an_engine.rb

    class << self
      def enhance!
        TASKS.each do |name|
          task = Rake::Task[name]
          task.enhance do
            if should_enhance?
              enhance_task(task)
            end
          end
        end

        PRE_TASKS.each do |name|
          task = Rake::Task[name]
          task.enhance([enhance_prerequisite_task(task)])
        end
      end

      def should_enhance?
        Apartment.db_migrate_tenants
      end

      def enhance_task(task)
        Rake::Task[task.name.sub(/db:/, 'apartment:')].invoke
      end

      # NOTE: prerequisite task always be called unless you configure
      #       Apartment.db_migrate_tenants. So, To run only if Apartment.db_migrate_tenants == true,
      #       We prepared _xxx task (e.g. db:_drop) that is
      #       only to check Apartment.db_migrate_tenants and run xxx task or not.
      def enhance_prerequisite_task(task)
        Rake::Task[task.name.sub(/db:/, 'apartment:_')]
      end
    end

  end
end

Apartment::RakeTaskEnhancer.enhance!
