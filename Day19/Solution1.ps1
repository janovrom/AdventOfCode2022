$fileData = Get-Content ".\input.txt"

# each array is cost of (ore, clay, obsidian, geode) robot
$blueprints = New-Object 'System.Collections.Generic.List[object]'
foreach ($line in $fileData)
{
    # load blueprint
    $blueprint = ConvertFrom-Json $line
    [void]$blueprints.Add($blueprint)
}

$Results = [System.Collections.Concurrent.ConcurrentDictionary[object, object]]::new()

$blueprints | Foreach-Object -ThrottleLimit 5 -Parallel {
    $blueprint = $_
    # [ore robot, clay robot, obsidian robot, geode robot, ore, clay, obsidian, geode, minute]
    $initialState = @(1,0,0,0,0,0,0,0,0)
    $stack = New-Object 'System.Collections.Generic.Stack[object]'
    [void]$stack.Push(@() + $initialState)
    $highestGeodeCount = 0
    # We can cut the branch, if we created geode robot at some time and the branch does not have it at the same time.
    $timeToCut = [System.Int32]::MaxValue
    $iter = 0
    while ($stack.Count -gt 0)
    {
        $iter +=1

        $state = $stack.Peek()
        [void]$stack.Pop()

        if ($state[8] -ge $timeToCut -and $state[3] -eq 0)
        {
            continue
        }

        if ($state[3] -eq 0 -and $state[8] -eq 23)
        {
            # Even if we start now, it's too late
            continue
        }

        if ($state[8] -eq 24)
        {
            # Time's out
            $highestGeodeCount = [System.Math]::Max($highestGeodeCount, $state[7])
            continue
        }

        # Increase time
        $state[8] += 1

        $newStates = New-Object 'System.Collections.Generic.List[object]'
        # Find what can be built 
        # Prefer geodes first
        for ($i = 3; $i -ge 0; $i--)
        {
            $canBuild = $true
            for ($j = 0; $j -lt 3; $j++)
            {
                if ($state[$j + 4] -lt $blueprint[$i][$j])
                {
                    $canBuild = $false
                    break
                }
            }

            if ($canBuild)
            {
                # If adding geode robot, update the remaining time to cut branches
                if ($i -eq 3)
                {
                    $timeToCut = [System.Math]::Min($timeToCut, $state[8])
                }

                $newState = @() + $state
                # Add robot
                $newState[$i] += 1
                # Remove ores
                for ($j = 0; $j -lt 3; $j++)
                {
                    $newState[$j + 4] -= $blueprint[$i][$j]
                }

                $newStates.Add($newState)
            }
        }

        # Collect
        if ($newStates.Count -ne 3)
        {
            $state[4] += $state[0]
            $state[5] += $state[1]
            $state[6] += $state[2]
            $state[7] += $state[3]
            $stack.Push($state)
        }

        # Add current state before so that we prioritize building
        foreach ($newState in $newStates)
        {
            $newState[4] += $state[0]
            $newState[5] += $state[1]
            $newState[6] += $state[2]
            $newState[7] += $state[3]
            
            $stack.Push($newState)
        }
    }

    ($using:Results).TryAdd($blueprint, $highestGeodeCount)
    Write-Host "Finished in" $iter "iterations"
}

$idx = 1
foreach ($blueprint in $blueprints)
{
    $result = -1
    $idx += 1
    [void]$Results.TryGetValue($blueprint, [ref]$result)
    Write-Host "Blueprint" $idx "collects at most" $result "geodes"
}