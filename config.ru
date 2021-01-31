require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use CoachesController
use CoachingSessionsController
use FramesController
use FrameBrandsController
use FrameModelsController
use LocationsController
use MatchesController
use OpponentsController
use RacquetsController
use SportsController
use StringsController
use StringBrandsController
use StringModelsController
use UsersController
run ApplicationController