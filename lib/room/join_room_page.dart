import 'package:nars/conference/conference_cubit.dart';
import 'package:nars/conference/conference_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nars/room/join_room_cubit.dart';
import 'package:nars/shared/twilio_service.dart';

class JoinRoomPage extends StatelessWidget {
  const JoinRoomPage({
    Key? key,
    required this.username,
    required this.appointmentId,
  }) : super(key: key);

  final String username;
  final int appointmentId;

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) =>
                RoomCubit(backendService: TwilioFunctionsService.instance),
            child: BlocConsumer<RoomCubit, RoomState>(
              listener: (context, state) async {
                if (state is RoomLoaded) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<ConferencePage>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) =>
                            // ConferencePage(roomModel: bloc),
                            BlocProvider(
                              create: (BuildContext context) => ConferenceCubit(
                                identity: state.identity,
                                token: state.token,
                                name: state.name,
                              ),
                              child: const ConferencePage(),
                            )),
                  );
                }
              },
              builder: (context, state) {
                var isLoading = false;
                RoomCubit bloc = context.read<RoomCubit>();
                if (state is RoomLoading) {
                  isLoading = true;
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // TextField(
                            //   key: Key('enter-name'),
                            //   decoration: InputDecoration(
                            //     labelText: 'Enter your name',
                            //     enabled: !isLoading,
                            //   ),
                            //   controller: _nameController,
                            //   onChanged: (newValue) =>
                            //       context.read<RoomCubit>().name = newValue,
                            // ),
                            // TextField(
                            //   key: Key('enter-room'),
                            //   decoration: InputDecoration(
                            //     labelText: 'Enter room name',
                            //     enabled: !isLoading,
                            //   ),
                            //   controller: _roomController,
                            //   onChanged: (newValue) =>
                            //       context.read<RoomCubit>().room = newValue,
                            // ),
                            const SizedBox(
                              height: 16,
                            ),
                            (isLoading == true)
                                ? const LinearProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      await bloc.submit();
                                    },
                                    child: const Text('Enter the room')),
                            (state is RoomError)
                                ? Text(
                                    state.error,
                                    style: const TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
