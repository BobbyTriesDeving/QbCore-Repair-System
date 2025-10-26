local QBCore = exports['qb-core']:GetCoreObject()

exports.ox_target:addGlobalVehicle({
    {
        name = 'repair_vehicle',
        icon = 'fa-solid fa-wrench',
        label = 'Repair Vehicle',
        distance = 2.0,
        onSelect = function(data)
            local ped = PlayerPedId()
            local vehicle = data.entity

            if not vehicle or not DoesEntityExist(vehicle) then
                lib.notify({title = 'Error', description = 'No vehicle found.', type = 'error'})
                return
            end

            local hasItem = exports.ox_inventory:Search('count', Config.RepairItem)

            if hasItem and hasItem > 0 then
                local success = lib.skillCheck(Config.SkillCheck.difficulties, Config.SkillCheck.keys)

                if success then
                    lib.progressBar({
                        duration = Config.RepairTime,
                        label = 'Repairing vehicle...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true },
                        anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
                    }, function(cancelled)
                        if not cancelled then
                            SetVehicleFixed(vehicle)
                            SetVehicleDeformationFixed(vehicle)
                            SetVehicleDirtLevel(vehicle, 0.0)
                            SetVehicleEngineHealth(vehicle, 1000.0)
                            SetVehiclePetrolTankHealth(vehicle, 1000.0)
                            exports.ox_inventory:RemoveItem(Config.RepairItem, 1)
                            lib.notify({title = 'Vehicle Repaired', description = 'You successfully repaired the vehicle.', type = 'success'})
                        else
                            lib.notify({title = 'Cancelled', description = 'Repair cancelled.', type = 'error'})
                        end
                    end)
                else
                    lib.notify({title = 'Failed', description = 'You failed to repair the vehicle.', type = 'error'})
                end
            else
                lib.notify({title = 'Missing Item', description = 'You need a repair kit to do this.', type = 'error'})
            end
        end
    }
})
